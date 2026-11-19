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
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.6.1/pulp-tui-v0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "c050f7f438c8a6604c548bea09f1437581f7b8d9b213ac280ebd8fb169554ea6"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.6.1/pulp-tui-v0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "c050f7f438c8a6604c548bea09f1437581f7b8d9b213ac280ebd8fb169554ea6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.6.1/pulp-tui-v0.6.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "eb8b380abf4743cef9bc3d5a61bf34dfc4efb7de574d70a15b815dec27c47f6b"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.6.1/pulp-tui-v0.6.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a87e955e9cf76816416c5abe9394b4891e68f8636f66b5bae1b794397d2d9128"
    end
  end

  def install
    bin.install "pulp-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp-tui --version")
  end
end
