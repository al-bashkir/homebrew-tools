class PulpTui < Formula
  desc "Keyboard-driven terminal UI for Pulp 3 repositories and content views"
  homepage "https://github.com/al-bashkir/pulp-tui"
  license "Apache-2.0"

  # Upstream ships no x86_64-apple-darwin asset. The arch dep makes brew refuse
  # macOS Intel before any fetch. The on_intel stub reuses the arm64 URL only so
  # the formula passes the tap-syntax check on every runner. Replace the stub
  # with a real URL and drop the arch dep once upstream builds that target.
  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.3.0/pulp-tui-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "989594f788d705b97fa731b8fdfb6d8cb9fe951d40a3ad034d88bb8e1d422ca9"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.3.0/pulp-tui-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "989594f788d705b97fa731b8fdfb6d8cb9fe951d40a3ad034d88bb8e1d422ca9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.3.0/pulp-tui-v0.3.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "acd0d2b26784031ae955736a318f6b4be72f4940578db5c13a467477470f1227"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.3.0/pulp-tui-v0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ef30c688778fe6c61652c80076518c4305d2f4769193a7837dd42e803f8d01db"
    end
  end

  def install
    bin.install "pulp-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp-tui --version")
  end
end
