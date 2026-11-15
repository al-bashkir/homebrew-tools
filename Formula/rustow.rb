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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.4.0/rustow-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "9e911aeb7c1fc32dc084bf362771858d916692a97fa9ea0c0c73a4bd14ef4f8a"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.4.0/rustow-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "9e911aeb7c1fc32dc084bf362771858d916692a97fa9ea0c0c73a4bd14ef4f8a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.4.0/rustow-v0.4.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "132ac7cdf9846184b06b03106d3e491fbca2d1c25ffaf271230840b6adf80c32"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.4.0/rustow-v0.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "935efe83b0ed905fdca630b278ee222ecf62fc130b7777d80f1238bb01114e11"
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
