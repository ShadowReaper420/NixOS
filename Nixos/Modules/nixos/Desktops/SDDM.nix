{pkgs, ...}:

  pkgs.stdenv.mkDerivation {
   name = "candy-sddm";
   src = pkgs.fetchFromGitHub {
     owner = "ShadowReaper420";
     repo = "SDDM-Theme";
     rev = "bd9a72df3cc2ab9fc8eae7ba4589cb1b837043b1";
     sha256 = "1p0hsv6i919mlbnq024i6cv8xlhbvr8bgvbjspb9945hzrphlh4l";

   };
   installPhase = ''
     mkdir -p $out
     cp -R ./* #out/
     '';
  }
