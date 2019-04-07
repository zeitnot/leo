[![Build Status](https://travis-ci.org/zeitnot/leo.svg?branch=master)](https://travis-ci.org/zeitnot/leo)
[![Maintainability](https://api.codeclimate.com/v1/badges/105e973fa36d7d032acf/maintainability)](https://codeclimate.com/github/zeitnot/leo/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/105e973fa36d7d032acf/test_coverage)](https://codeclimate.com/github/zeitnot/leo/test_coverage)

### Requirements
ruby `>= 2.3`

### Installation
* `$ git clone git@github.com:zeitnot/leo.git`
* `$ bundle install`
* `$ rake`

### Usage
Type `$ bin/console` on your terminal. To list routes type: 
```ruby
# Without any parameter, it lists all routes by defaul.
Leo.list_routes #=> 

{
  :sentinels => [{
      :start_node => "alpha",
      :end_node => "beta",
      :start_time => "2030-12-31T13:00:01",
      :end_time => "2030-12-31T13:00:02"
    },
    {
      :start_node => "beta",
      :end_node => "gamma",
      :start_time => "2030-12-31T13:00:02",
      :end_time => "2030-12-31T13:00:03"
    },
    {
      :start_node => "delta",
      :end_node => "beta",
      :start_time => "2030-12-31T13:00:02",
      :end_time => "2030-12-31T13:00:03"
    },
    {
      :start_node => "beta",
      :end_node => "gamma",
      :start_time => "2030-12-31T13:00:03",
      :end_time => "2030-12-31T13:00:04"
    }
  ],:sniffers => [{
      :start_node => "lambda",
      :end_node => "tau",
      :start_time => "2030-12-31T13:00:06",
      :end_time => "2030-12-31T13:00:07"
    },
    {
      :start_node => "tau",
      :end_node => "psi",
      :start_time => "2030-12-31T13:00:06",
      :end_time => "2030-12-31T13:00:07"
    },
    {
      :start_node => "psi",
      :end_node => "omega",
      :start_time => "2030-12-31T13:00:06",
      :end_time => "2030-12-31T13:00:07"
    },
    {
      :start_node => "lambda",
      :end_node => "psi",
      :start_time => "2030-12-31T13:00:07",
      :end_time => "2030-12-31T13:00:08"
    },
    {
      :start_node => "psi",
      :end_node => "omega",
      :start_time => "2030-12-31T13:00:07",
      :end_time => "2030-12-31T13:00:08"
    }
  ],:loopholes => [{
      :start_node => "gamma",
      :end_node => "theta",
      :start_time => "2030-12-31T13:00:04",
      :end_time => "2030-12-31T13:00:05"
    },
    {
      :start_node => "theta",
      :end_node => "lambda",
      :start_time => "2030-12-31T13:00:05",
      :end_time => "2030-12-31T13:00:06"
    },
    {
      :start_node => "beta",
      :end_node => "theta",
      :start_time => "2030-12-31T13:00:05",
      :end_time => "2030-12-31T13:00:06"
    },
    {
      :start_node => "theta",
      :end_node => "lambda",
      :start_time => "2030-12-31T13:00:06",
      :end_time => "2030-12-31T13:00:07"
    }
  ]
}


# Or to narrow the list it accepts parameters of source names 
  

Leo.list_routes :sentinels, :loopholes #=>

{
  :sentinels => [{
      :start_node => "alpha",
      :end_node => "beta",
      :start_time => "2030-12-31T13:00:01",
      :end_time => "2030-12-31T13:00:02"
    },
    {
      :start_node => "beta",
      :end_node => "gamma",
      :start_time => "2030-12-31T13:00:02",
      :end_time => "2030-12-31T13:00:03"
    },
    {
      :start_node => "delta",
      :end_node => "beta",
      :start_time => "2030-12-31T13:00:02",
      :end_time => "2030-12-31T13:00:03"
    },
    {
      :start_node => "beta",
      :end_node => "gamma",
      :start_time => "2030-12-31T13:00:03",
      :end_time => "2030-12-31T13:00:04"
    }
  ],:loopholes => [{
      :start_node => "gamma",
      :end_node => "theta",
      :start_time => "2030-12-31T13:00:04",
      :end_time => "2030-12-31T13:00:05"
    },
    {
      :start_node => "theta",
      :end_node => "lambda",
      :start_time => "2030-12-31T13:00:05",
      :end_time => "2030-12-31T13:00:06"
    },
    {
      :start_node => "beta",
      :end_node => "theta",
      :start_time => "2030-12-31T13:00:05",
      :end_time => "2030-12-31T13:00:06"
    },
    {
      :start_node => "theta",
      :end_node => "lambda",
      :start_time => "2030-12-31T13:00:06",
      :end_time => "2030-12-31T13:00:07"
    }
  ]
}

```

In order to post routes jus type on your console: 
```ruby
Leo.post_routes #=> {} Empty hash means all routes are posted to server.
Leo.post_routes #=> 
{
  [:sentinels, 'alpha', 'beta']=>false,
  [:loopholes, 'beta', 'theta']=>false
} 

# The preceding example show that from sentinels source; alpha to beta route,
# and from loopholes source; beta to theta route are not posted. 
```