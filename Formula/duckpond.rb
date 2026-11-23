class Duckpond < Formula
  desc "Encrypted environment-variable profiles with GPG or age passphrase"
  homepage "https://github.com/al-bashkir/duckpond"
  license "MIT"

  # No upstream x86_64-apple-darwin asset. The arch dep makes brew refuse
  # macOS Intel before any fetch. The on_intel stub reuses the arm64 URL only
  # so the formula passes the tap-syntax check on every runner. Replace the
  # stub with a real URL and drop the arch dep once upstream builds that target.
  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.2/duckpond-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "d68a17578599ae45fcf22a25a5d78ea6cb7a5ebcfc456c485dc4f8bdf01308db"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.2/duckpond-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "d68a17578599ae45fcf22a25a5d78ea6cb7a5ebcfc456c485dc4f8bdf01308db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.2/duckpond-v0.1.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0b5f5e635567c3daebe88c644f0757cd8474d9d55706e5d956308ea118cb4052"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.2/duckpond-v0.1.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "deeb3c942f29e35d03ed235b5b100c36fc59e47cf8a2d09edd737aabea4fb6fa"
    end
  end

  def install
    bin.install "duckpond"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckpond --version")
  end
end
