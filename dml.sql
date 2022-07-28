-- Characters
-- Create a Character
-- Read a list of Characters
-- Update a Character
-- Delete a Character, Delete all Spells associated with Character, Delete Actions Associated
INSERT INTO Characters (characterName, homeID, attack, health, mana, inParty, inBattle, abilityID)
VALUES
(:characterName, (SELECT homeID FROM Homes WHERE homeName = :homeName), :attack, :health, :mana, :inParty, :inBattle, (SELECT abilityID FROM Abilities WHERE abilityName = :abilityName));

SELECT * FROM Characters;

UPDATE Characters SET
characterName = :characterName, homeID = (SELECT homeID FROM Homes WHERE homeName = :homeName), attack = :attack, health = :health, mana = :mana, inParty = :inParty, inBattle = :inBattle, abilityID = (SELECT abilityID FROM Abilities WHERE abilityName = :abilityName)
WHERE characterName = :characterName;

DELETE FROM Characters WHERE characterName = :characterName;

-- CharacterSpells
-- Insert a Spell for a Character
-- Find a list of all Spells for a Character
-- Find a list of all Characters for a Spell
-- Delete a single Spell for a Character
INSERT INTO CharacterSpells (characterID, spellID)
VALUES
((SELECT characterID FROM Characters WHERE characterName = :characterName), (SELECT spellID FROM Spells WHERE spellName = :spellName));

SELECT characterName AS Character, spellName AS Spell 
FROM Characters c INNER JOIN CharacterSpells cs ON c.characterID = cs.characterID
INNER JOIN Spells s ON cs.spellID = s.spellID
WHERE c.characterName = :characterName;

DELETE FROM CharacterSpells WHERE characterID = (SELECT characterID FROM Characters WHERE characterName = :characterName) AND spellID = (SELECT spellID FROM Spells WHERE spellName = :spellName);

-- Homes
-- Insert a Home
-- Find all Characters for a given Home
-- Delete a Home
INSERT INTO Homes (homeName, postApocalyptic)
VALUES 
(homeName = :homeName, postApocalyptic = :postApocalyptic);

SELECT characterName AS Character FROM Characters c INNER JOIN 
Homes h ON c.homeID = h.homeID;

DELETE FROM Homes WHERE homeID = (SELECT homeID FROM Homes WHERE homeName = :homeName); 

-- Abilities
-- Create Ability
-- Generate a list of Abilities and Characters associated with
-- Update Ability
-- Delete Ability
INSERT INTO Abilities (abilityName, abilityEffect)
VALUES 
(:abilityName, :abilityEffect);

SELECT characterName AS Character, abilityName as Ability FROM Characters c INNER JOIN 
Abilities a ON c.abilityID = a.abilityID;

UPDATE Abilities SET
abilityName = :abilityName, abilityEffect = :abilityEffect
WHERE abilityName = :abilityName

DELETE FROM Abilities WHERE abilityID = (SELECT abilityID FROM Abilities WHERE abilityName = :AbilityName);

-- Spells
-- Create Spell
-- Generate list of Spells and Characters that can use it
-- Filter by spellType
-- Delete a Spell
INSERT INTO Spells (spellName, spellEffect, spellType)
VALUES 
(:spellName, :spellEffect, spellType);

SELECT characterName AS Character FROM Characters c INNER JOIN 
Spells s ON c.spellID = s.spellID WHERE spellName = :spellName;

SELECT * FROM Spells WHERE spellType = :spellType;

UPDATE Spells SET
spellName = :spellName, spellEffect = :spellEffect
WHERE spellName = :spellName

DELETE FROM Spells WHERE spellID = (SELECT spellID FROM Spells WHERE spellName = :spellName);

-- BattleActions
-- Generate list of Actions
-- Insert Action, and associated intersections
-- Update Action 
-- Delete Action
SELECT * FROM BattleActions;

INSERT INTO BattleActions (actionEffect) VALUES (:actionEffect);
INSERT INTO SpellActions (actionID, spellID) VALUES (:actionID, :spellID);
INSERT INTO AbilityActions (actionID, abilityID) VALUES (:actionID, :abilityID);
INSERT INTO CharacterActions (actionID, characterID) VALUES (:actionID, (SELECT characterID FROM Characters WHERE characterName = :characterName));

UPDATE BattleActions SET actionEffect = :actionEffect WHERE actionID = :actionID;

DELETE FROM BattleActions WHERE actionID = :actionID;

-- SpellActions 
-- Generate list of Actions by Spell
-- Delete SpellAction and associated BattleAction and CharacterAction
SELECT sa.actionID as 'Action #', ca.characterName as Character, s.spellName as Spell, ba.actionEffect as Effect FROM SpellActions sa 
JOIN BattleActions ba on sa.actionID = ba.actionID
JOIN CharacterActions ca on ca.actionID = ba.actionID
JOIN Characters c on c.characterID = ca.characterID
JOIN Spells s on s.spellID = sa.spellID;

DELETE FROM BattleActions WHERE actionID = :actionID;

-- AbilityActions
-- Generate list of Actions by Ability
-- Delete AbilityAction and associated BattleAction and CharacterAction
SELECT sa.actionID as 'Action #', c.characterName as Character, a.abilityName as Ability, ba.actionEffect as Effect FROM AbilityActions aa 
JOIN BattleActions ba on aa.actionID = ba.actionID
JOIN CharacterActions ca on ca.actionID = ba.actionID
JOIN Characters c on c.characterID = ca.characterID
JOIN Abilities a on a.abilityID = aa.abilityID;

DELETE FROM BattleActions WHERE actionID = :actionID;

-- CharacterActions 
-- Generate a list of Actions by Character
-- Delete CharacterAction and associated AbilityAction or SpellAction and BattleAction
SELECT sa.actionID as 'Action #', c.characterName as Character, s.spellName as Spell, a.abilityName as Ability, ba.actionEffect as Effect FROM AbilityActions aa 
JOIN BattleActions ba on aa.actionID = ba.actionID
JOIN SpellActions sa  on sa.actionID = ba.actionID
JOIN CharacterActions ca on ca.actionID = ba.actionID
JOIN Characters c on c.characterID = ca.characterID
JOIN Abilities a on a.abilityID = aa.abilityID
JOIN Spells s on s.spellID = sa.spellID;

DELETE FROM BattleActions WHERE actionID = :actionID;