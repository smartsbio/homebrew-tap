class Smarts < Formula
  desc "smarts.bio command-line interface"
  homepage "https://smarts.bio"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.2/smarts-aarch64-apple-darwin.tar.xz"
      sha256 "e3ec9d08cef0d1f283b6da2fc802fa59f3f9c05dc453c08083fdcbaa02f042c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.2/smarts-x86_64-apple-darwin.tar.xz"
      sha256 "4be1669b1155fd3d77b65ef0e33184f0ae623d77684c2a7137f4ed07c6d6def2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.2/smarts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3a292f6b66c1978727872fa1beae29a6923c6f1737a96e7f1a3395fa6f9d769e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.2/smarts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f0580b1615d9c945de8da9a7db5c6a8dee7fe719879c30a7c5b5f7eca47e8663"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "smarts" if OS.mac? && Hardware::CPU.arm?
    bin.install "smarts" if OS.mac? && Hardware::CPU.intel?
    bin.install "smarts" if OS.linux? && Hardware::CPU.arm?
    bin.install "smarts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
