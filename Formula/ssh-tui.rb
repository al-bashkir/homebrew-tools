class SshTui < Formula
  desc "TUI for managing SSH connections"
  homepage "https://github.com/al-bashkir/ssh-tui"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v1.3.3/ssh-tui_v1.3.3_darwin_arm64.tar.gz"
      sha256 "ac493a6f91298debceb57505b538f6ed0e1e0c93e4dd756277a59f80a87ea5de"
    end
    on_intel do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v1.3.3/ssh-tui_v1.3.3_darwin_amd64.tar.gz"
      sha256 "65a8ef3b0482f5a6f081d8bbfc7de9788adf1f1c0f5136a7b9fb7a59195b1f24"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v1.3.3/ssh-tui_v1.3.3_linux_arm64.tar.gz"
      sha256 "fbf25c0638be68ebae74947483352299f66d67c701e0508501e2c2d3d3c0ed81"
    end
    on_intel do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v1.3.3/ssh-tui_v1.3.3_linux_amd64.tar.gz"
      sha256 "4adf1cdc86a4a1b5e0a6631e32e2bc4e43856331635d836d25f1076c089da52a"
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
