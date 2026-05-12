class SshTui < Formula
  desc "TUI for managing SSH connections"
  homepage "https://github.com/al-bashkir/ssh-tui"
  version "1.3.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v#{version}/ssh-tui_v#{version}_darwin_arm64.tar.gz"
      sha256 "4ba05ac237fdd69e3d1b950681333786c85b170116e4479d7719f53adc8119e9"
    end
    on_intel do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v#{version}/ssh-tui_v#{version}_darwin_amd64.tar.gz"
      sha256 "97ec28862bb21739ea30a01782aba7725805cddf81aad00f5303aa7bb62411fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v#{version}/ssh-tui_v#{version}_linux_arm64.tar.gz"
      sha256 "81cc2ea7ce2b6bfff8c461d37e83aed6e13073739a78a49fe7e76b17b6eb954c"
    end
    on_intel do
      url "https://github.com/al-bashkir/ssh-tui/releases/download/v#{version}/ssh-tui_v#{version}_linux_amd64.tar.gz"
      sha256 "decb76b85ee3985a6c91e1f726a8f63e8e4c29a72ea6ccaf2b4c2a86d719ac57"
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
