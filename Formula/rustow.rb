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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.3.1/rustow-v0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "7f6aba89ee788c67e1b718a15370756210584db67fe5ab28f22d7a4310bfe4db"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.3.1/rustow-v0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "7f6aba89ee788c67e1b718a15370756210584db67fe5ab28f22d7a4310bfe4db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.3.1/rustow-v0.3.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "afadf6e44d0a51a5fdd4485c36590cc479a910c6eeae9b5f1a5804de394201cc"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.3.1/rustow-v0.3.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0c32f2276dc3773739e4ca2e4b86ed677da4f958e6253b05acf45ecfdf72998e"
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
