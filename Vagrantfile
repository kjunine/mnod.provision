# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "mnod/base"

  config.vm.define "database" do |database|
    database.vm.hostname = "database"
    database.vm.network "private_network", ip: "192.168.7.10"
    database.vm.network "forwarded_port", guest: 2375, host: 2376

    database.vm.provision :docker do |docker|
      docker.run "mongodb1",
        image: "kjunine/mongodb",
        args: "-p 27017:27017 -v /data --entrypoint=mongod",
        cmd: "--dbpath /data --replSet mnod"
      docker.run "mongodb2",
        image: "kjunine/mongodb",
        args: "-p 27018:27017 -v /data --entrypoint=mongod",
        cmd: "--dbpath /data --replSet mnod"
      docker.run "mongodb3",
        image: "kjunine/mongodb",
        args: "-p 27019:27017 -v /data --entrypoint=mongod",
        cmd: "--dbpath /data --replSet mnod"
      docker.run "kjunine/mongodb-replset-configurator",
        daemonize: false,
        args: "--rm -e MRSC_ID=mnod \
          -e MRSC_SERVERS=192.168.7.10:27017,192.168.7.10:27018 -e MRSC_ARBITERS=192.168.7.10:27019"
    end
  end

  config.vm.define "application" do |application|
    application.vm.hostname = "application"
    application.vm.network "private_network", ip: "192.168.7.20"
    application.vm.network "forwarded_port", guest: 2375, host: 2377
    application.vm.network "forwarded_port", guest: 8080, host: 8080

    application.vm.provision :docker do |docker|
      docker.run "kjunine/mnod",
        args: "-p 8080:8080 \
          -e MONGOHQ_URL=mongodb://192.168.7.10:27017,192.168.7.10:27018/mnod?replicaSet=mnod \
          -e NEW_RELIC_LICENSE_KEY=#{ENV['NEW_RELIC_LICENSE_KEY']}"
    end
  end
end
