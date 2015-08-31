-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


-- drop DB tournament if exist
DROP DATABASE IF EXISTS tournament;

-- create DB tournament
CREATE DATABASE tournament;

-- psql command to connect to tournament db
\c tournament

-- create TABLE players with 2 columns id and name
CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    name TEXT
);

-- create TABLE matches with 3 columns id, winner and loser
CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    winner  INTEGER REFERENCES players (id),
    loser  INTEGER REFERENCES players (id)
);

-- Create a VIEW standings in tournament DB, making a SELECT
-- (players.id, players.name, wins, matches_played) to count
-- wins and matches played in table matches for every player
-- in TABLE players (group result with aggregate function)
-- in descending order by wins

CREATE VIEW standings AS
	SELECT players.id AS player_id, players.name,
		(SELECT COUNT(matches.winner)
			FROM matches
			WHERE matches.winner = players.id)
		AS wins,
		(SELECT COUNT(matches.winner)
			FROM matches
			WHERE players.id
			IN (winner, loser))
		AS matches_played
	FROM players
	GROUP BY players.id
	ORDER BY wins DESC;