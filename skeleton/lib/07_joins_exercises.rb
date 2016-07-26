# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT
    m.title
  FROM
    movies m
  JOIN
    castings c on m.id = c.movie_id
  JOIN
    actors a on a.id = c.actor_id
  where
    a.name = 'Harrison Ford';
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  SELECT
    m.title
  FROM
    movies m
  JOIN
    castings c ON m.id = c.movie_id
  JOIN
    actors a ON a.id = c.actor_id
  where
    a.name = 'Harrison Ford' AND c.ord != 1;
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
    m.title, a.name
  FROM
    movies m
  JOIN
    castings c ON m.id = c.movie_id
  JOIN
    actors a On a.id = c.actor_id
  WHERE
    m.yr = 1962 AND c.ord = 1;
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
    m.yr, count(*) movie_count
  FROM
    movies m
  JOIN
    castings c ON m.id = c.movie_id
  JOIN
    actors a On a.id = c.actor_id
  WHERE
    a.name = 'John Travolta'
  GROUP BY
    m.yr
  HAVING
    count(*) >= 2;
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  SELECT
    m.title, star.name
  FROM
    movies m
  JOIN
    castings star_castings ON m.id = star_castings.movie_id
  JOIN
    actors star On star.id = star_castings.actor_id
  JOIN
    castings julie_castings ON m.id = julie_castings.movie_id
  JOIN
    actors julie_andrews ON julie_andrews.id = julie_castings.actor_id
  WHERE
    star_castings.ord = 1 AND julie_andrews.name = 'Julie Andrews';
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    SELECT
      a.name
    FROM
      movies m
    JOIN
      castings c ON m.id = c.movie_id
    JOIN
      actors a On a.id = c.actor_id
    WHERE
      c.ord = 1
    GROUP BY
      a.name
    HAVING
      COUNT(*) >= 15
    ORDER BY
      a.name;
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
    SELECT
      m.title, count(*)
    FROM
      movies m
    JOIN
      castings c ON m.id = c.movie_id
    JOIN
      actors a On a.id = c.actor_id
    WHERE
      m.yr = 1978
    GROUP BY
      m.id
    ORDER BY
      COUNT(*) DESC, m.title ASC;
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
    SELECT
      other.name
    FROM
      movies m
    JOIN
      castings other_castings ON m.id = other_castings.movie_id
    JOIN
      actors other On other.id = other_castings.actor_id
    JOIN
      castings art_castings ON m.id = art_castings.movie_id
    JOIN
      actors art_garfunkel ON art_garfunkel.id = art_castings.actor_id
    WHERE
      art_garfunkel.name = 'Art Garfunkel' AND other.name != 'Art Garfunkel';
  SQL
end
