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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.11.1/rustow-v0.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "ba214b1b5b25bf5487703f4d6698217dfc24aadd6cbd80a6c7a8eb7bb0dd7ad1"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.11.1/rustow-v0.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "ba214b1b5b25bf5487703f4d6698217dfc24aadd6cbd80a6c7a8eb7bb0dd7ad1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.11.1/rustow-v0.11.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7fa4d143ad5262888d08f24bfe3348b5bfe4acb10dcf35befe417e13c10876d0"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.11.1/rustow-v0.11.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a851054e797e9fae6e282b3c3a2a3ce408d2fe3f5efa352abba00ae9b018c6f3"
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
