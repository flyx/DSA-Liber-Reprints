{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.11;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachSystem flake-utils.lib.allSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-basic latexmk pgf pdfpages pdflscape tikzpagenodes ifoddpage;
      };
      makePrintable = input: name: front: source: pkgs.stdenvNoCC.mkDerivation {
        inherit name;
        nativeBuildInputs = [ pkgs.poppler_utils pkgs.imagemagick tex ];
        src = self;
        phases = ["unpackPhase" "buildPhase" "installPhase"];
        MAGICK = "${pkgs.imagemagick}/bin/magick";
        buildPhase = ''
          cp ${input} input.pdf
          ${front}
          mkdir -p .cache/texmf-var
          env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
            ${tex}/bin/latexmk -lualatex -interaction=nonstopmode \
            ${source}.tex
        '';
        installPhase = ''
          mkdir $out
          mv ${source}.pdf $out/${name}.pdf
        '';
      };
      liturgiumFront = ''
        ${pkgs.poppler_utils}/bin/pdfimages -f 1 -l 1 input.pdf image
        $MAGICK convert image-000.ppm front.jpg
        $MAGICK convert front.jpg -gravity North -chop 0x1114 -flip bottom.jpg
        $MAGICK convert front.jpg -gravity South -chop 0x1114 -flip top.jpg
        $MAGICK top.jpg front.jpg bottom.jpg -append fullheight.jpg
        $MAGICK convert fullheight.jpg -gravity West -chop 704x0 right.jpg
        $MAGICK convert fullheight.jpg -gravity West -chop 792x0 filler.jpg
        $MAGICK convert fullheight.jpg -gravity East -chop 704x0 left.jpg
        $MAGICK convert right.jpg -flop right-mirror.jpg
        $MAGICK convert left.jpg -flop left-mirror.jpg
        $MAGICK filler.jpg right.jpg left.jpg right-mirror.jpg left-mirror.jpg left.jpg right.jpg right-mirror.jpg left-mirror.jpg fullheight.jpg right-mirror.jpg +append full.jpg
      '';
      cantionesFront = ''
        ${pkgs.poppler_utils}/bin/pdfimages -f 1 -l 1 input.pdf front
        ${pkgs.poppler_utils}/bin/pdfimages -f 306 -l 306 input.pdf back
        ${pkgs.poppler_utils}/bin/pdfimages -f 305 -l 305 input.pdf right
        ${pkgs.poppler_utils}/bin/pdfimages -f 304 -l 304 input.pdf left
        $MAGICK convert front-000.ppm front.jpg
        $MAGICK convert back-000.ppm back.jpg
        $MAGICK convert right-000.ppm right.jpg
        $MAGICK convert left-000.ppm left.jpg
        $MAGICK convert front.jpg -gravity North -chop 0x1114 -flip bottom.jpg
        $MAGICK convert front.jpg -gravity South -chop 0x1114 -flip top.jpg
        $MAGICK top.jpg front.jpg bottom.jpg -append fullfront.jpg
        $MAGICK top.jpg back.jpg bottom.jpg -append fullback.jpg
        $MAGICK convert fullfront.jpg -gravity East -chop 790x0 pusher.jpg
        $MAGICK convert fullfront.jpg -gravity East -chop 780x0 filler.jpg
        $MAGICK pusher.jpg fullback.jpg filler.jpg fullfront.jpg filler.jpg pusher.jpg +append full.jpg
      '';
    in {
      packages = {
        liberLiturgium = makePrintable ./LiberLiturgium.pdf "LiberLiturgium-print" liturgiumFront "ll";
        liberCantiones = makePrintable ./LiberCantiones.pdf "LiberCantiones-print" cantionesFront "lc";
      };
    });
}