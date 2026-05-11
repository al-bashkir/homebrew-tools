class Envio < Formula
  desc "Modern and secure CLI tool for managing environment variables"
  homepage "https://github.com/al-bashkir/envio"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/envio/releases/download/v0.6.3/envio-v0.6.3-aarch64-apple-darwin.tar.gz"
      sha256 "d54b380c75c9e2ee87a80288e20114532499f6a66a0bfa1952ce8dbc11f193a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/envio/releases/download/v0.6.3/envio-v0.6.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6724d3503fef8b5298d4fa87487e1368c3f431fe61932d51d8edea37bd4e3ec0"
    end
    on_intel do
      url "https://github.com/al-bashkir/envio/releases/download/v0.6.3/envio-v0.6.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "27e724b0c906fc682936366640e34105af7f580bfaa1787b9fe2d9c4956d44ad"
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
