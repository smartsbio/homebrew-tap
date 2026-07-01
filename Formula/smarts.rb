class Smarts < Formula
  desc "smarts.bio command-line interface"
  homepage "https://smarts.bio"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.8/smarts-aarch64-apple-darwin.tar.xz"
      sha256 "23cedd8c9fe69166ce2b55fd7c403e0e31b5e96a78a7d898913316da0b8a63cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.8/smarts-x86_64-apple-darwin.tar.xz"
      sha256 "b764e58bb80fd1f36f97d00186e173f18d03379f99a3c5a468da3428b4c689b0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.8/smarts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ad6bc5495d5c1ffc9b7c825779f0dfb5e936cfa2a46c432484355f2d91aae8bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.8/smarts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ef295955e5e00e760cd3f3b1b57c943a81e6c4f6403245d5bc10686688c9600"
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
