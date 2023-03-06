Vagrant.configure("2") do |config|
  servers=[
    {
      :hostname => "prod",
      :box => "bento/ubuntu-18.04",
      :ip => "172.16.1.52",
      :ssh_port => '2202'
    },
    {
        :hostname => "git-server",
        :box => "bento/ubuntu-18.04",
        :ip => "172.16.1.60",
        :ssh_port => '2222'
      },
    {
        :hostname => "ansible-control",
        :box => "bento/ubuntu-18.04",
        :ip => "172.16.1.80",
        :ssh_port => '22224'
      },
      {
      :hostname => "jenkins",
      :box => "bento/ubuntu-18.04",
      :ip => "172.16.1.70",
      :ssh_port => '2223'
    }
    ]


  servers.each do |machine|
      config.vm.define machine[:hostname] do |node|
          node.vm.box = machine[:box]
          node.vm.hostname = machine[:hostname]
          node.vm.network :private_network, ip: machine[:ip]
          node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
          node.vm.provider :virtualbox do |vb|
              vb.customize ["modifyvm", :id, "--memory", 512]
              vb.customize ["modifyvm", :id, "--cpus", 1]
          end
      end
  end
end