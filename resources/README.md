Druid Extensions
----------------
From a working druid install (brew install druid) you can pull the dependencies of a non-core extension like this:
```
cd /usr/local/Cellar/druid/<druid_version>/libexec

java   -cp "lib/*"   -Ddruid.extensions.directory="extensions"   -Ddruid.extensions.hadoopDependenciesDir="hadoop-dependencies"   io.druid.cli.Main tools pull-deps   --no-default-hadoop   -c "io.druid.extensions.contrib:graphite-emitter:<druid_version>"

cd extensions/
tar -cvzf graphite-emitter-extensions-<druid_version>.tar.gz graphite-emitter-extensions
```
