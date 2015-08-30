-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


-- drop DB if exist
DROP DATABASE IF EXISTS tournament;

-- create  DB tournament
CREATE DATABASE tournament;

-- psql command to connect to tournament db
\c tournament

-- create TABLE players;
CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    name TEXT
);

-- create TABLE matches;
CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    winner  INTEGER REFERENCES players (id),
    loser  INTEGER REFERENCES players (id)
);

-- create VIEW standings
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