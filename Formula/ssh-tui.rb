class SshTui < Formula
  desc "TUI for managing SSH connections"
  homepage "https://github.com/al-bashkir/ssh-tui"
  url "https://github.com/al-bashkir/ssh-tui/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "6a107ccd9bec1aa30da7eb029192f48e845a1df7c1fbd95923e24d5534facd49"
  license :cannot_represent

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"ssh-tui"), "./cmd/ssh-tui"
  end

  test do
    assert_path_exists bin/"ssh-tui"
    assert_predicate bin/"ssh-tui", :executable?
  end
end
