class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "http://www.quut.com/gsm/"
  url "http://www.quut.com/gsm/gsm-1.0.17.tar.gz"
  sha256 "855a57d1694941ddf3c73cb79b8d0b3891e9c9e7870b4981613b734e1ad07601"

  bottle do
    cellar :any
    rebuild 1
    sha256 "379e5da09c1733b6eb0cca6c33fa3332a26bb53ae09bab7739f398e644a9e7e4" => :sierra
    sha256 "d1a329a6594db0bf0d4d743bd38bda1e07e566292a32a700df6fc73f6a9739d3" => :el_capitan
    sha256 "c67758c5298dc6d36a5bb201eb42821862647aa79df0ee2824df708ac388db48" => :yosemite
    sha256 "c25d6ffc2bf063c8c824093ca83b6de17ebbca52c062c4344cddbb8b8286169c" => :mavericks
    sha256 "8b9054832ecbd7a4e41b1b3e7f8ef7a4aa4e0006a5332a19d176119c6b4121f3" => :mountain_lion
  end

  # Builds a dynamic library for gsm, this package is no longer developed
  # upstream. Patch taken from Debian and modified to build a dylib.
  patch do
    url "https://gist.githubusercontent.com/dholm/5840964/raw/1e2bea34876b3f7583888b2284b0e51d6f0e21f4/gistfile1.txt"
    sha256 "3b47c28991df93b5c23659011e9d99feecade8f2623762041a5dcc0f5686ffd9"
  end

  def install
    ENV.append_to_cflags "-c -O2 -DNeedFunctionPrototypes=1"

    # Only the targets for which a directory exists will be installed
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath

    # Dynamic library must be built first
    system "make", "lib/libgsm.1.0.13.dylib",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "all",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "install",
           "INSTALL_ROOT=#{prefix}",
           "GSM_INSTALL_INC=#{include}"
    lib.install Dir["lib/*dylib"]
  end
end
