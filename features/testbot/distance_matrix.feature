@matrix @testbot
Feature: Basic Distance Matrix
# note that results of travel distance are in metres

    Background:
        Given the profile "testbot"
        And the partition extra arguments "--small-component-size 1 --max-cell-sizes 2,4,8,16"

    Scenario: Testbot - Travel distance matrix of minimal network
        Given the node map
            """
            a b
            """

        And the ways
            | nodes |
            | ab    |

        When I request a travel distance matrix I should get
            |   |   a   |   b   |
            | a | 0     | 99.98 |
            | b | 99.98 | 0     |

    Scenario: Testbot - Travel distance matrix of minimal network with excludes
        Given the query options
            | exclude  | toll        |

        Given the node map
            """
            a b
            c d
            """

        And the ways
            | nodes | highway  | toll | #                                        |
            | ab    | motorway |      | not drivable for exclude=motorway        |
            | cd    | primary  |      | always drivable                          |
            | ac    | motorway | yes  | not drivable for exclude=toll and exclude=motorway,toll |
            | bd    | motorway | yes  | not drivable for exclude=toll and exclude=motorway,toll |

        When I request a travel distance matrix I should get
            |   |   a   |   b    |   c   |  d    |
            | a |   0   |  99.98 |       |       |
            | b | 99.98 |   0    |       |       |
            | c |       |        |   0   | 99.98 |
            | d |       |        | 99.98 |   0   |

    Scenario: Testbot - Travel distance matrix of minimal network with different exclude
        Given the query options
            | exclude  | motorway  |

        Given the node map
            """
            a b
            c d
            """

        And the ways
            | nodes | highway  | toll | #                                        |
            | ab    | motorway |      | not drivable for exclude=motorway        |
            | cd    | primary  |      | always drivable                          |
            | ac    | motorway | yes  | not drivable for exclude=toll and exclude=motorway,toll |
            | bd    | motorway | yes  | not drivable for exclude=toll and exclude=motorway,toll |

        When I request a travel distance matrix I should get
            |   |   a    |   b    |   c    |   d    |
            | a |   0    |        |        |        |
            | b |        |   0    |        |        |
            | c |        |        |   0    |  99.97 |
            | d | 299.96 |        |  99.95 |   0    |


    Scenario: Testbot - Travel distance matrix of minimal network with excludes combination
        Given the query options
            | exclude  | motorway,toll  |

        Given the node map
            """
            a b
            c d
            """

        And the ways
            | nodes | highway  | toll | #                                        |
            | ab    | motorway |      | not drivable for exclude=motorway        |
            | cd    | primary  |      | always drivable                          |
            | ac    | motorway | yes  | not drivable for exclude=toll and exclude=motorway,toll |
            | bd    | motorway | yes  | not drivable for exclude=toll and exclude=motorway,toll |

        When I request a travel distance matrix I should get
            |   | a  | b  | c     | d     |
            | a | 0  |    |       |       |
            | b |    | 0  |       |       |
            | c |    |    | 0     | 99.98 |
            | d |    |    | 99.98 |  0    |

    Scenario: Testbot - Travel distance matrix with different way speeds
        Given the node map
            """
            a b c d
            """

        And the ways
            | nodes | highway   |
            | ab    | primary   |
            | bc    | secondary |
            | cd    | tertiary  |

        When I request a travel distance matrix I should get
            |   |   a    |   b    |    c   |    d   |
            | a |   0    | 99.98  | 199.95 | 299.93 |
            | b | 99.98  |   0    | 99.98  | 199.95 |
            | c | 199.95 | 99.98  |   0    | 99.98  |
            | d | 299.93 | 199.95 | 99.98  |   0    |

        When I request a travel distance matrix I should get
            |   | a |   b   |   c    |   d    |
            | a | 0 | 99.98 | 199.95 | 299.93 |

        When I request a travel distance matrix I should get
            |   |   a    |
            | a |   0    |
            | b | 99.98  |
            | c | 199.95 |
            | d | 299.93 |

    Scenario: Testbot - Travel distance matrix of small grid
        Given the node map
            """
            a b c
            d e f
            """

        And the ways
            | nodes |
            | abc   |
            | def   |
            | ad    |
            | be    |
            | cf    |

        When I request a travel distance matrix I should get
            |   |   a    |   b    |   e    |   f    |
            | a |   0    | 99.98  | 199.97 | 299.95 |
            | b | 99.98  |   0    | 99.98  | 199.97 |
            | e | 199.97 | 99.98  |   0    |  99.98 |
            | f | 299.93 | 199.95 | 99.98  |   0    |


    Scenario: Testbot - Travel distance matrix of network with unroutable parts
        Given the node map
            """
            a b
            """

        And the ways
            | nodes | oneway |
            | ab    | yes    |

        When I request a travel distance matrix I should get
            |   | a | b        |
            | a | 0 | 99.98    |
            | b |   | 0        |

    Scenario: Testbot - Travel distance matrix of network with oneways
        Given the node map
            """
            x a b y
              d e
            """

        And the ways
            | nodes | oneway |
            | abeda | yes    |
            | xa    |        |
            | by    |        |

        When I request a travel distance matrix I should get
            |   |     x   |     y   |     d   |     e   |
            | x |     0   |  299.93 |  399.92 |  299.95 |
            | y |  499.92 |     0   |  299.95 |  199.97 |
            | d |  199.97 |  299.95 |    0    |  299.96 |
            | e |  299.95 |  399.92 |  99.98  |    0    |

    Scenario: Testbot - Rectangular travel distance matrix
        Given the node map
            """
            a b c
            d e f
            """

        And the ways
            | nodes |
            | abc   |
            | def   |
            | ad    |
            | be    |
            | cf    |

        When I request a travel distance matrix I should get
            |   | a | b     | e      | f      |
            | a | 0 | 99.98 | 199.97 | 299.95 |

        When I request a travel distance matrix I should get
            |   | a      |
            | a | 0      |
            | b | 99.98  |
            | e | 199.97 |
            | f | 299.95 |

        When I request a travel distance matrix I should get
            |   | a     | b     | e      | f      |
            | a | 0     | 99.98 | 199.97 | 299.95 |
            | b | 99.98 | 0     | 99.98  | 199.97 |

        When I request a travel distance matrix I should get
            |   | a      | b      |
            | a | 0      | 99.98  |
            | b | 99.98  | 0      |
            | e | 199.97 | 99.98  |
            | f | 299.95 | 199.97 |

        When I request a travel distance matrix I should get
            |   | a      | b     | e      | f      |
            | a | 0      | 99.98 | 199.97 | 299.95 |
            | b | 99.98  | 0     | 99.98  | 199.97 |
            | e | 199.97 | 99.98 | 0      | 99.98  |

        When I request a travel distance matrix I should get
            |   | a      | b      | e      |
            | a | 0      | 99.98  | 199.97 |
            | b | 99.98  | 0      | 99.98  |
            | e | 199.97 | 99.98  | 0      |
            | f | 299.95 | 199.97 | 99.98  |

        When I request a travel distance matrix I should get
            |   | a      | b      | e      | f      |
            | a | 0      | 99.98  | 199.97 | 299.95 |
            | b | 99.98  | 0      | 99.98  | 199.97 |
            | e | 199.97 | 99.98  | 0      | 99.98  |
            | f | 299.95 | 199.97 | 99.98  | 0      |


     Scenario: Testbot - Travel distance 3x2 matrix
        Given the node map
            """
            a b c
            d e f
            """

        And the ways
            | nodes |
            | abc   |
            | def   |
            | ad    |
            | be    |
            | cf    |


        When I request a travel distance matrix I should get
            |   | b     | e      | f      |
            | a | 99.98 | 199.97 | 299.95 |
            | b | 0     | 99.98  | 199.97 |

    Scenario: Testbot - All coordinates are from same small component
        Given a grid size of 300 meters
        Given the extract extra arguments "--small-component-size 4"
        Given the node map
            """
            a b   f
            d e   g
            """

        And the ways
            | nodes |
            | ab    |
            | be    |
            | ed    |
            | da    |
            | fg    |

        When I request a travel distance matrix I should get
            |   | f      | g      |
            | f | 0      | 299.98 |
            | g | 299.98 | 0      |

    Scenario: Testbot - Coordinates are from different small component and snap to big CC
        Given a grid size of 300 meters
        Given the extract extra arguments "--small-component-size 4"
        Given the node map
            """
            a b   f h
            d e   g i
            """

        And the ways
            | nodes |
            | ab    |
            | be    |
            | ed    |
            | da    |
            | fg    |
            | hi    |

        When I request a travel distance matrix I should get
            |   | f      | g      | h      | i      |
            | f | 0      | 599.91 | 0      | 599.91 |
            | g | 599.91 | 0      | 599.91 | 0      |
            | h | 0      | 599.91 | 0      | 599.91 |
            | i | 599.91 | 0      | 599.91 | 0      |

    Scenario: Testbot - Travel distance matrix with loops
        Given the node map
            """
            a 1 2 b
            d 4 3 c
            """

        And the ways
            | nodes | oneway |
            | ab    | yes |
            | bc    | yes |
            | cd    | yes |
            | da    | yes |

        When I request a travel distance matrix I should get
            |   | 1          | 2          | 3          | 4          |
            | 1 | 0          | 99.98 +-1  | 399.92 +-1 | 499.92 +-1 |
            | 2 | 699.92 +-1 | 0          | 299.95 +-1 | 399.92 +-1 |
            | 3 | 399.92 +-1 | 499.92 +-1 | 0          | 99.98 +-1  |
            | 4 | 299.95 +-1 | 399.92 +-1 | 699.92 +-1 | 0          |

    Scenario: Testbot - Travel distance matrix based on segment durations
        Given the profile file
        """
        local functions = require('testbot')
        functions.setup_testbot = functions.setup

        functions.setup = function()
          local profile = functions.setup_testbot()
          profile.traffic_signal_penalty = 0
          profile.u_turn_penalty = 0
          return profile
        end

        functions.process_segment = function(profile, segment)
          segment.weight = 2
          segment.duration = 11
        end

        return functions
        """

        And the node map
          """
          a-b-c-d
              .
              e
          """

        And the ways
          | nodes |
          | abcd  |
          | ce    |

        When I request a travel distance matrix I should get
          |   | a      | b      | c      | d      | e      |
          | a | 0      | 99.98  | 199.95 | 299.95 | 399.92 |
          | b | 99.98  | 0      | 99.98  | 199.97 | 299.96 |
          | c | 199.97 | 99.98  | 0      | 99.98  | 199.98 |
          | d | 299.95 | 199.97 | 99.98  | 0      | 299.95 |
          | e | 399.92 | 299.96 | 199.97 | 299.95 | 0      |

    Scenario: Testbot - Travel distance matrix for alternative loop paths
        Given the profile file
        """
        local functions = require('testbot')
        functions.setup_testbot = functions.setup

        functions.setup = function()
          local profile = functions.setup_testbot()
          profile.traffic_signal_penalty = 0
          profile.u_turn_penalty = 0
          profile.weight_precision = 3
          return profile
        end

        functions.process_segment = function(profile, segment)
          segment.weight = 777
          segment.duration = 3
        end

        return functions
        """
        And the node map
            """
            a 2 1 b
            7     4
            8     3
            c 5 6 d
            """

        And the ways
            | nodes | oneway |
            | ab    | yes    |
            | bd    | yes    |
            | dc    | yes    |
            | ca    | yes    |

        When I request a travel distance matrix I should get
          |   | 1      | 2       | 3      | 4       | 5      | 6       | 7      | 8       |
          | 1 | 0      | 1099.84 | 299.96 | 199.97  | 599.91 | 499.93  | 899.87 | 799.88  |
          | 2 | 99.98  | 0       | 399.94 | 299.95  | 699.89 | 599.91  | 999.85 | 899.86  |
          | 3 | 899.86 | 799.88  | 0      | 1099.83 | 299.95 | 199.97  | 599.91 | 499.92  |
          | 4 | 999.85 | 899.87  | 99.99  | 0       | 399.94 | 299.96  | 699.9  | 599.91  |
          | 5 | 599.91 | 499.93  | 899.87 | 799.88  | 0      | 1099.84 | 299.96 | 199.97  |
          | 6 | 699.89 | 599.91  | 999.85 | 899.86  | 99.98  | 0       | 399.94 | 299.95  |
          | 7 | 299.95 | 199.97  | 599.91 | 499.92  | 899.86 | 799.88  | 0      | 1099.83 |
          | 8 | 399.94 | 299.96  | 699.9  | 599.91  | 999.85 | 899.87  | 99.99  | 0       |

    Scenario: Testbot - Travel distance matrix with ties
        Given the profile file
        """
        local functions = require('testbot')
        functions.process_segment = function(profile, segment)
          segment.weight = 1
          segment.duration = 1
        end
        functions.process_turn = function(profile, turn)
          if turn.angle >= 0 then
            turn.duration = 16
          else
            turn.duration = 4
          end
          turn.weight = 0
        end
        return functions
        """
        And the node map
            """
            a     b

            c     d
            """

        And the ways
          | nodes |
          | ab    |
          | ac    |
          | bd    |
          | dc    |


        When I route I should get
          | from | to | route | distance | time | weight |
          | a    | c  | ac,ac | 200m     | 5s   |      5 |

        When I route I should get
          | from | to | route    | distance |
          | a    | b  | ab,ab    | 299.9m   |
          | a    | c  | ac,ac    | 200m     |
          | a    | d  | ac,dc,dc | 499.9m   |

        When I request a travel distance matrix I should get
          |   | a | b      | c      | d      |
          | a | 0 | 299.93 | 199.97 | 499.92 |

        When I request a travel distance matrix I should get
          |   | a      |
          | a | 0      |
          | b | 299.95 |
          | c | 199.97 |
          | d | 499.92 |
