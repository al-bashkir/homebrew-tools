class SshTui < Formula
  desc "TUI for managing SSH connections"
  homepage "https://github.com/al-bashkir/ssh-tui"
  version "1.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v#{version}/ssh-tui_v#{version}_darwin_arm64.tar.gz"
      sha256 "1679a9a28b087a135f6a2cca350018c9cc3b191da69f4f3ad5ace2941489d4e9"
    end
    on_intel do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v#{version}/ssh-tui_v#{version}_darwin_amd64.tar.gz"
      sha256 "8fa732946f60652c7505b70b8212d9c5a86db60851041c5e6e9e05a9e25beb11"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v#{version}/ssh-tui_v#{version}_linux_arm64.tar.gz"
      sha256 "f7ed3cbdebf272e24205060f6857e6f1a4a675bc735596dcfe1527e3976c2289"
    end
    on_intel do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v#{version}/ssh-tui_v#{version}_linux_amd64.tar.gz"
      sha256 "394b8406dcacb7246504bae513a9cf4e5061560553c36735f13ec4fccff65692"
    end
  end

  def install
    bin.install "ssh-tui"
    generate_completions_from_executable(bin/"ssh-tui", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_path_exists bin/"ssh-tui"
    assert_predicate bin/"ssh-tui", :executable?
  end
end
