SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- TABLE DEFINITIONS

CREATE OR REPLACE TABLE Spells (
    spellID int AUTO_INCREMENT UNIQUE NOT NULL,
    spellName varchar(50) NOT NULL,
    spellEffect varchar(255) NOT NULL,
    spellType varchar(50) NOT NULL,
    PRIMARY KEY (spellID)
);

CREATE OR REPLACE TABLE Abilities (
    abilityID int AUTO_INCREMENT UNIQUE NOT NULL,
    abilityName varchar(50) NOT NULL,
    abilityEffect varchar(255) NOT NULL,
    PRIMARY KEY (abilityID)
);

CREATE OR REPLACE TABLE Homes (
    homeID int AUTO_INCREMENT UNIQUE NOT NULL,
    homeName varchar(50) NOT NULL,
    postApocalyptic boolean NOT NULL,
    PRIMARY KEY (homeID)
);

CREATE OR REPLACE TABLE Characters (
    characterID int AUTO_INCREMENT UNIQUE NOT NULL,
    characterName varchar(50) NOT NULL,
    homeID int NOT NULL,
    attack int NOT NULL,
    health int NOT NULL,
    mana int NOT NULL,
    inParty boolean NOT NULL,
    inBattle boolean NOT NULL,
    abilityID int NOT NULL,
    PRIMARY KEY (characterID),
    FOREIGN KEY (homeID)
    REFERENCES Homes(homeID)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (abilityID)
    REFERENCES Abilities(abilityID)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE OR REPLACE TABLE BattleActions (
    actionID int AUTO_INCREMENT UNIQUE NOT NULL,
    effect text NULL
);

CREATE OR REPLACE TABLE SpellActions(
    spellActionID int AUTO_INCREMENT UNIQUE NOT NULL, 
    spellID int NOT NULL, 
    actionID int NOT NULL,
    PRIMARY KEY (spellActionID),
    FOREIGN KEY (spellID)
    REFERENCES Spells(spellID)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (actionID)
    REFERENCES BattleActions(actionID)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE OR REPLACE TABLE AbilityActions(
    abilityActionID int AUTO_INCREMENT UNIQUE NOT NULL,
    abilityID int NOT NULL,
    actionID int NOT NULL,
    PRIMARY KEY (abilityActionID),
    FOREIGN KEY (abilityID)
    REFERENCES Abilities(abilityID)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (actionID)
    REFERENCES BattleActions(actionID)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE OR REPLACE TABLE CharacterActions(
    characterActionID int AUTO_INCREMENT UNIQUE NOT NULL,
    characterID int NOT NULL,
    actionID int NOT NULL,
    PRIMARY KEY (characterActionID),
    FOREIGN KEY (characterID)
    REFERENCES Characters(CharacterID)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (actionID)
    REFERENCES BattleActions(actionID)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- SAMPLE DATA

INSERT INTO Spells (spellName, spellEffect, spellType)
VALUES 
('fire', 'cost 4mp damage single 50hp', 'fire'),
('firaga', 'cost 12mp damage all 400hp proc chance to incinerate', 'fire'),
('ice', 'cost 4mp damage single 50hp', 'ice'),
('blizzaga', 'cost 12mp damage all 400hp proc chance to slow', 'ice'),
('lightning', 'cost 4mp damage single 50hp', 'lightning'),
('luminaire', 'cost 12mp damage all 400hp proc chance to blind', 'lightning'),
('aero', 'cost 4mp damage single 50hp', 'wind'),
('aeraga', 'cost 12mp damage all 400hp proc chance to confuse', 'wind'),
('quake', 'cost 4mp damage single 50hp', 'earth'),
('quaga', 'cost 12mp damage all 400hp proc chance to stun', 'earth'),
('cure', 'cost 4mp restore single ally 100hp', 'life'),
('esuna', 'cost 2mp remove negative status effects single char', 'life'),
('revive', 'cost 12mp revive single ally 100hp', 'life'),
('slow', 'cost 6mp half turn recovery single char', 'time');

INSERT INTO Abilities (abilityName, abilityEffect)
VALUES 
('braver', 'damage single 3x attack'),
('trance', 'transform into esper state for 5 turns. 2x attack 2x magic def'),
('black hole', 'send an enemy to the nether realm '),
('electrocute', 'stun and damage all electronic enemies 400'),
('apocalypse', 'damage all heroes 700');

INSERT INTO Homes (homeName, postApocalyptic)
VALUES 
('Nibelheim', false),
('Esper World', false),
('Zeal', false),
('Proto Dome', true),
('Unknown', false);

INSERT INTO Characters (characterName, homeID, attack, health, mana, inParty, inBattle, abilityID)
VALUES 
('Cloud Strife', (SELECT homeID FROM Homes WHERE homeName = 'Nibelheim'), 90, 999, 99, true, true, (SELECT abilityID FROM Abilities WHERE abilityName = 'braver')),
('Terra', (SELECT homeID FROM Homes WHERE homeName = 'Esper World'), 64, 999, 99, true, true, (SELECT abilityID FROM Abilities WHERE abilityName = 'trance')),
('Magus', (SELECT homeID FROM Homes WHERE homeName = 'Zeal'), 82, 999, 99, true, true, (SELECT abilityID FROM Abilities WHERE abilityName = 'black hole')),
('Robo', (SELECT homeID FROM Homes WHERE homeName = 'Proto Dome'), 96, 999, 99, false, false, (SELECT abilityID FROM Abilities WHERE abilityName = 'electrocute')),
('Lavos', (SELECT homeID FROM Homes WHERE homeName = 'Unknown'), 99, 999, 99, false, true, (SELECT abilityID FROM Abilities WHERE abilityName = 'apocalypse'));

INSERT INTO BattleActions (actionID, effect)
VALUES 
(1, 'all heroes damaged 700hp'),
(2, 'heal Terra 100hp'),
(3, 'Terra 2x attack 2x magic def for 5 turns');

INSERT INTO SpellActions (spellID, actionID)
VALUES
((SELECT spellID FROM Spells WHERE spellName = 'cure'), 2);

INSERT INTO AbilityActions(abilityID, actionID)
VALUES
((SELECT abilityID FROM Abilities WHERE abilityName = 'apocalypse'), 1),
((SELECT abilityID FROM Abilities WHERE abilityName = 'trance'), 3);

INSERT INTO CharacterActions(characterID, actionID)
VALUES
((SELECT characterID FROM Characters WHERE characterName = 'Lavos'), 1),
((SELECT characterID FROM Characters WHERE characterName = 'Cloud Strife'), 2),
((SELECT characterID FROM Characters WHERE characterName = 'Terra'), 3);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;