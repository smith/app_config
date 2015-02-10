# AppConfig Cookbook

This cookbook provides some tools that make managing application configuration
more convenient.

## How's That?

When using Chef to configure an application, what's the best mechanism to use to
store that configuration data? Node attributes? Sure, those are good for some
things. What about secrets? chef-vault or encrypted data bag items might be
good, but not for everything. How about data bags? OK, sure. Maybe you just have
a few things in a Hash that you want to add too.

The AppConfig object lets you take data from different sources like this, deep merge
it all together, and output it in ways amenable to using in configuration files.

## Usage

Add this cookbook to your dependencies in metadata.rb:

```ruby
depends "app_config"
```

In a recipe:

```ruby
app_config = AppConfig.new(
  chef_vault_item("secrets", "my_app_secrets"),
  data_bag_item("my_app"),
  node['my_app'],
  { :other_data_for => "my_app" }
)
```

Any list of Hash-like objects will do as arguments.

The AppConfig object inherits from Chef's
[Mash](http://www.rubydoc.info/gems/chef/Mash), and inherits all of those
methods.

### Output Formats

It's best to use a `file` resource along with AppConfig objects:

```ruby
file "my_config.yml" do
  content app_config.to_yaml
end
```

#### to_yaml

Outputs YAML, but doesn't use any of the object indicators (`!ruby/hash:Mash`,
etc.), which can cause problems with some applications that read YAML as
configuration data.

#### to_environment_variables

Programs like [direnv](http://direnv.net/) and
[dotenv](https://github.com/bkeepers/dotenv), make it easy to load environment
variables from files into your app. With `#to_environment_variables`, you can
write those files. A data structure that looks like:

```ruby
{
  :github_key => "abcde",
  :api_username => "testuser",
  :feature_flag_x => true
}
```

Will output a string that looks like:

```
export GITHUB_KEY="abcde"
export API_USERNAME="testuser"
export FEATURE_FLAG_X="true"
```

This works if you use a flat structure. Strings, numbers, and booleans will all
output as strings. Collection objects like arrays and hashes will be ignored.
Keys will be uppercased, as is conventional with environment variables.

### Sharing Data Across Recipes

If you need to share the config data object between separate recipes, create the
AppConfig object in the first recipe you load and use the `node.run_state`:

```ruby
# recipe A
node.run_state[:app_config] ||= AppConfig.new(...)

# recipe B
include_recipe "my_cookbook:recipe_a"
app_config = node.run_state[:app_config]
```

## Contributing

### Running the Specs

If you're using [ChefDK](http://downloads.chef.io/chef-dk/), run
`chef exec rspec` to run the RSpec tests.

## License

Copyright (c) 2015 Nathan L Smith

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
