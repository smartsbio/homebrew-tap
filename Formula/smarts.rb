class Smarts < Formula
  desc "smarts.bio command-line interface"
  homepage "https://smarts.bio"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.6/smarts-aarch64-apple-darwin.tar.xz"
      sha256 "5110b44564d0ddb14d94e0cd89d9ccbb6ba98176f62edfa1b20942e74b406f56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.6/smarts-x86_64-apple-darwin.tar.xz"
      sha256 "8119c9b3143f9a0281cc786601376f38ccde6b4936c66c4d0832dc9f71dece3c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.6/smarts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1616975372ff5554d9aee99131faf4cf4fe4ecb7ff0a8556db246bca4cc4a72b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.6/smarts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "027eeff514cf37e30e228a7eaff503263a1286716f4c6315325ee2bc649e9e5a"
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
