class Envio < Formula
  desc "Modern and secure CLI tool for managing environment variables"
  homepage "https://github.com/al-bashkir/envio"
  url "https://github.com/al-bashkir/envio/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "d146772fb14db28c26e4f4b5854c60633d3a8e55ae841b12a29cfd0df46a73c9"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/envio.1"
    bash_completion.install "completions/envio.bash" => "envio"
    fish_completion.install "completions/envio.fish"
    zsh_completion.install  "completions/_envio"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envio version")
  end
end
