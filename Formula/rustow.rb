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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.5.0/rustow-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "e7b81b11b1ddaab2994edacdc548a60b8e3acabc493654dee3ca07f88f6c324f"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.5.0/rustow-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "e7b81b11b1ddaab2994edacdc548a60b8e3acabc493654dee3ca07f88f6c324f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.5.0/rustow-v0.5.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a51032612797157df44bd508aa8df36aed30fceca9dcf8ae2932d9318749239e"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.5.0/rustow-v0.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "64eb5a067199dc981231f607758b1ea744a014950d2116bc33cb08b00954ee5b"
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
