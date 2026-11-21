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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.8.0/rustow-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "bb316d1b899d526102a0874fb3e871c42ff65d29c22f0b673233ec41fef4248c"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.8.0/rustow-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "bb316d1b899d526102a0874fb3e871c42ff65d29c22f0b673233ec41fef4248c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.8.0/rustow-v0.8.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2e88adf4189bbff6a1576c0bd9aee3038f5405d203c13bf2584685ba9b82a779"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.8.0/rustow-v0.8.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ce4697b95aa9b4d6236d90ac3abfeca242ccae505a279ba67b59f6b6f6633dd2"
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
