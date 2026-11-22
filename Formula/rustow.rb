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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.10.0/rustow-v0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "3dc9fb0f400ffda048d84bac340ba6e2ab83574ebf7d4b950cab5bcf54f09375"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.10.0/rustow-v0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "3dc9fb0f400ffda048d84bac340ba6e2ab83574ebf7d4b950cab5bcf54f09375"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.10.0/rustow-v0.10.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8d028d539db9940e80af79438690cf596882b69232170c840913332af03a5b30"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.10.0/rustow-v0.10.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9f33d51e3615358351004f452d4d65da03f89665cfa4a4aca887a511219de834"
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
