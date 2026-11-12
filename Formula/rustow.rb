class Rustow < Formula
  desc "Flat-repository dotfiles manager with templates and age/GPG secrets"
  homepage "https://github.com/al-bashkir/rustow"
  license "MIT"

  # Upstream ships no x86_64-apple-darwin asset. The arch dep makes brew refuse
  # macOS Intel before any fetch. The on_intel stub reuses the arm64 URL only so
  # the formula passes the tap-syntax check on every runner. Replace the stub
  # with a real URL and drop the arch dep once upstream builds that target.
  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.1.0/rustow-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "1f8f10f751240d79b3ea5da262f77371702cf06f61b572778bc6297838b77234"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.1.0/rustow-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "1f8f10f751240d79b3ea5da262f77371702cf06f61b572778bc6297838b77234"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.1.0/rustow-v0.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5e855c6b33076439635c878d6562f2c67f1b1a4971bb0d140579978986eabd08"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.1.0/rustow-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7cb6ac3d03d1d3bf21321a9cf01716b1945badac286e051e695b2e265c4535ed"
    end
  end

  def install
    bin.install "rustow"
    bash_completion.install "completions/rustow.bash" => "rustow"
    fish_completion.install "completions/rustow.fish"
    zsh_completion.install  "completions/_rustow"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustow --version")
  end
end
