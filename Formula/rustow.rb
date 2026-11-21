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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.9.0/rustow-v0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "0310fdc694085d6e1156606937b409cd4ab90b24a6a90e39d7b906ed2da09ea0"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.9.0/rustow-v0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "0310fdc694085d6e1156606937b409cd4ab90b24a6a90e39d7b906ed2da09ea0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.9.0/rustow-v0.9.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d934095d1f4e61f8b8cb86c24b5a7fe6b2a1a8728e840740eedb16e34f5ef7c1"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.9.0/rustow-v0.9.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f0e86a204633571f8bb9a54011fb2468fa570e177a468c3da58f1757a781779c"
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
