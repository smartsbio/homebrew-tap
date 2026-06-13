class Smarts < Formula
  desc "smarts.bio command-line interface"
  homepage "https://smarts.bio"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.1/smarts-aarch64-apple-darwin.tar.xz"
      sha256 "1ec30083219f77c1746664b1148bb8b1732f55c3d8667ecd60c999b7303ceda8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.1/smarts-x86_64-apple-darwin.tar.xz"
      sha256 "4621b290a35d98781e9163be8ce22bcce86bc4dc745dac380b55b479f1927343"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.1/smarts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3c3b1735d5d1ff1cc8a207065cedb7b9f8e3a1099c7964cec5b7189074e1ced8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.1/smarts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f86a710efc48f7b601a6659515a615197160df6d7bc85cd4dde2b49171c92f7a"
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
