class Smarts < Formula
  desc "smarts.bio command-line interface"
  homepage "https://smarts.bio"
  version "0.1.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.13/smarts-aarch64-apple-darwin.tar.xz"
      sha256 "f3d6c7d8f1a5474b386cf0c196094cfa31b4de2144031fc739c16b5391611b1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.13/smarts-x86_64-apple-darwin.tar.xz"
      sha256 "ba31b4be07e5c19121b9068e959edf0be212325368ea0a86fa06856c368d5d4d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.13/smarts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "020ac3ad68ca01a1dee6ae2e5381771eb62aa07a311b02aedcd697d8f168232e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.13/smarts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69a7d666abe223739ea684b225591516e8cfd602fa4b41d23f9fd2e3e045399d"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "smarts"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "smarts"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "smarts"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "smarts"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
