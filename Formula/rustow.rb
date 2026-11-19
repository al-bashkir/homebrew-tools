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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.6.1/rustow-v0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "048726d6b0dac158b7263a794fa099b0c126e5a86cd49e476342486e40a9c58d"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.6.1/rustow-v0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "048726d6b0dac158b7263a794fa099b0c126e5a86cd49e476342486e40a9c58d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.6.1/rustow-v0.6.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "02e2f9fee368722e79569e74708354890ed32832d2dd70d4e69c7a53405e8b6c"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.6.1/rustow-v0.6.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "89c356a30c41a6d4bb65b22f6a873b33d5542bd997db9dbd52ab1610724891ed"
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
