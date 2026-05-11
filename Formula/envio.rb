class Envio < Formula
  desc "Modern and secure CLI tool for managing environment variables"
  homepage "https://github.com/al-bashkir/envio"
  url "https://github.com/al-bashkir/envio/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "71fece9784a7a5f9ee2688a141b6f2ca8fa8c348e928b7d810e5167687acb103"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build
  depends_on "gpgme"

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
