require "json"

module ATotp
  VERSION = "0.1.0"
  ENV["PATH"] = "/usr/local/bin:/usr/bin"

  # This could possibly be cached.
  # 0..-2 because this always returns a newline at the end, giving an extra element without.
  def self.ids
    `security dump-keychain atotp.keychain | grep 0x00000007 | awk -F= '{print $2}' | tr -d \'"'`.split("\n")[0..-2]
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
      code = gen_code get_pass(id)
      {
        uid: id,
        title: id,
        subtitle: code,
        arg: code
      }
    end
  end

  print({ items: alfred_out }.to_json)
end

