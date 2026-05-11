class Envio < Formula
  desc "Modern and secure CLI tool for managing environment variables"
  homepage "https://github.com/al-bashkir/envio"
  license any_of: ["MIT", "Apache-2.0"]

  # On macOS, the upstream binary is built against Homebrew's gpgme on the
  # macos-14 runner, so it dynamic-links Homebrew paths and brew must install
  # gpgme alongside. On Linux, the upstream binary is built in a cross-rs
  # container against the container's apt gpgme/libgpg-error, so it references
  # system /lib64 paths instead of Homebrew's prefix; users must have system
  # gpgme installed (`apt install libgpgme11 libgpg-error0`, `dnf install
  # gpgme libgpg-error`, etc.). Declaring the deps unconditionally would either
  # mislead Linux users (the brew copy is not actually used) or fail
  # `brew linkage --test` for "unwanted system libraries".
  on_macos do
    depends_on arch: :arm64
    depends_on "gpgme"
    depends_on "libgpg-error"

    on_arm do
      url "https://github.com/al-bashkir/envio/releases/download/v0.6.6/envio-v0.6.6-aarch64-apple-darwin.tar.gz"
      sha256 "652a27e184ee2884f5c82ceccbb0c9e19f1d1e9e704e07193cf6edd2d4ee0d0b"
    end
    on_intel do
      # No upstream x86_64-apple-darwin asset. `depends_on arch: :arm64` above
      # makes brew refuse to install on Intel macOS before this URL is ever
      # fetched. The arm64 URL is reused only so the formula passes the
      # tap-syntax check on Intel macOS runners. Replace with a real x86_64
      # URL and drop the arch dep once envio CICD.yml builds one.
      url "https://github.com/al-bashkir/envio/releases/download/v0.6.6/envio-v0.6.6-aarch64-apple-darwin.tar.gz"
      sha256 "652a27e184ee2884f5c82ceccbb0c9e19f1d1e9e704e07193cf6edd2d4ee0d0b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/envio/releases/download/v0.6.6/envio-v0.6.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87eae40802ffb86156baa52a581282a62ece59d551ad1eead35533dc7c79b858"
    end
    on_intel do
      url "https://github.com/al-bashkir/envio/releases/download/v0.6.6/envio-v0.6.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d43e760ca5d78d76d3bf9083200c8df774422be9a2d1f9f24882f1ec348441da"
    end
  end

  def install
    bin.install "envio"
    man1.install "envio.1"
    bash_completion.install "autocomplete/envio.bash" => "envio"
    fish_completion.install "autocomplete/envio.fish"
    zsh_completion.install  "autocomplete/_envio"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envio version")
  end
end
