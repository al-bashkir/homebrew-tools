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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.2.2/rustow-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "27cfd15a1b5b48c38a3e07c40a13dae66771ea218bb9cc60c641b84c486fc896"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.2.2/rustow-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "27cfd15a1b5b48c38a3e07c40a13dae66771ea218bb9cc60c641b84c486fc896"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.2.2/rustow-v0.2.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fdbee6dc94968e5f8399ac5b507779216e708f43360160178a77163da2d89c46"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.2.2/rustow-v0.2.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3b0530e6ea8857bf074169c53e7c0c4c616f7422d8c29366c8ffd15aff6bbf72"
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
