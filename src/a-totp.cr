require "json"

module ATotp
  VERSION = "0.1.0"
  ENV["PATH"] = "/usr/local/bin:/usr/bin"

  # This could possibly be cached.
  def self.ids
    `security dump-keychain atotp.keychain | grep 0x00000007 | awk -F= '{print $2}' | tr -d \'"'`.strip.split("\n")
  end

  def self.gen_code(pass)
    io = IO::Memory.new
    Process.run("oathtool", ["--totp", "-b", pass], output: io)
    io.to_s.strip
  end

  def self.get_pass(id)
    io = IO::Memory.new
    Process.run("security", ["find-generic-password", "-s", id, "-w", "atotp.keychain"], output: io)
    io.to_s.strip
  end

  def self.alfred_out
    ids.map do |id|
      pass = get_pass id
      code = gen_code pass
      {
        uid: id,
        title: id,
        subtitle: code,
        arg: pass,
        mods: {
          alt: {
            valid: true,
            subtitle: "copy #{code}",
            arg: pass,
          }
        }
      }
    end
  end

  print({ rerun: 1, items: alfred_out }.to_json)
end

