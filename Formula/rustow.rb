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
      url "https://github.com/al-bashkir/rustow/releases/download/v0.3.0/rustow-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "d09f922d54b6de57493bcc8af7131695488f50b0607045be62ae419fb819e5e6"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.3.0/rustow-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "d09f922d54b6de57493bcc8af7131695488f50b0607045be62ae419fb819e5e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.3.0/rustow-v0.3.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "13356a013629425051cecdc2646c8b73dda36ce16012366038e18a8166be288f"
    end
    on_intel do
      url "https://github.com/al-bashkir/rustow/releases/download/v0.3.0/rustow-v0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9601067236601c6b10e6ee03ae3e9984f41634372519123aaeb5df58bc4aa0c6"
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
