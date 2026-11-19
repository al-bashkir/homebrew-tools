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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.6.0/rustow-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "176003dd59c65aae90edad7c5711edbb9eb98331c44f7097c149af0174237aba"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.6.0/rustow-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "176003dd59c65aae90edad7c5711edbb9eb98331c44f7097c149af0174237aba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.6.0/rustow-v0.6.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7bd51320b70c9486f22e6947001e71f6a12006ec859e555c0037e43fedca567e"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.6.0/rustow-v0.6.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2b56637a598f028b0bda13cf3e722a12c939a023d009910ee6dac9830e41baa4"
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
