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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.7.0/rustow-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "435740444770c56492fd4ae1b5204a864dc93516361b6a068dec3ff176edbc7c"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.7.0/rustow-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "435740444770c56492fd4ae1b5204a864dc93516361b6a068dec3ff176edbc7c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.7.0/rustow-v0.7.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f781d23eacfc655e0c0554cff913f2ed37341efbc29ac65545094fe5c4db9430"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.7.0/rustow-v0.7.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b2255688cd6fe9ecb2a2da37fbe18991965a547d6effb48eb5ca571fee8a858e"
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
