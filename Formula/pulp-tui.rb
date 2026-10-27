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
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.1.1/pulp-tui-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "85668ce849f91e949a61ab79e53722036540bfc6ab1dd156905dbff8e5048ffa"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.1.1/pulp-tui-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "85668ce849f91e949a61ab79e53722036540bfc6ab1dd156905dbff8e5048ffa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.1.1/pulp-tui-v0.1.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e87a44a23d175af3a50c26583f03d303c6c0d6661589e43ad5641200946ffeb4"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.1.1/pulp-tui-v0.1.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cdc6034f93f65d8617237006dcaf81ff9ee5b3efd2b3c0725281aa2f1e80a81d"
    end
  end

  def install
    bin.install "pulp-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp-tui --version")
  end
end
