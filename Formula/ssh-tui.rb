class SshTui < Formula
  desc "TUI for managing SSH connections"
  homepage "https://github.com/al-bashkir/ssh-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v1.3.4/ssh-tui_v1.3.4_darwin_arm64.tar.gz"
      sha256 "8d43485aceaf7c3fc263d34f6cb11fc2691ad3969743321515d317797f63a041"
    end
    on_intel do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v1.3.4/ssh-tui_v1.3.4_darwin_amd64.tar.gz"
      sha256 "19dddcfdb0528a644d06e5c6c76054a0f9657084207af2054aa1c5ebf83e77d8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v1.3.4/ssh-tui_v1.3.4_linux_arm64.tar.gz"
      sha256 "df4c9b8296ef9c434c2d78298e1d9679a2cd0fc03f69b45a5ac47a9c6982e7e3"
    end
    on_intel do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v1.3.4/ssh-tui_v1.3.4_linux_amd64.tar.gz"
      sha256 "b9009d8cdde285b24438b2265d3edd3836be6eb9e88c641d369aea372fed71ba"
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
