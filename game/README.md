game
====

Gierka Rogalik

How to run
----------

```bash
git clone
cd gierka-rogalik/game
flutter pub get

# For any browser
flutter run -d web-server --web-port 8080

# For Chrome - better debug tools
flutter run -d chrome

# For running locally
flutter run
```

Note:

The difference between Enemy and EnemyComponent in the context of a Flame game in Flutter typically relates to the separation of game logic and rendering. This distinction is based on the Entity-Component-System (ECS) architecture, which is a common pattern used in game development. Here's a breakdown of their roles:
Enemy (Entity)

    Role: The Enemy class represents the concept of an enemy as an entity in your game. It usually contains the game logic and state that defines what an enemy is and how it behaves.
    Contents: This class might include properties like health, speed, AI behavior, and any other attributes that define the enemy's characteristics and actions.
    Behavior: Methods in this class typically involve how the enemy interacts with the game world, such as moving, attacking, reacting to the player, or making decisions (AI).

EnemyComponent (Component)

    Role: The EnemyComponent class is a specific implementation of a component in the Flame game engine. It's focused on the rendering and interaction of the enemy entity within the game's visual and component system.
    Flame Integration: In Flame, a Component is a basic building block for anything that needs to be updated and rendered. So, EnemyComponent would handle how the enemy is drawn, animated, and how it appears on the screen.
    Interaction with Flame's System: It would include methods for updating the enemy's position, handling animations, and responding to user inputs or collisions.

In Practice

In your game, you might have an Enemy class that contains the core logic of what an enemy does. Then, you would have an EnemyComponent class that extends Flame's Component class (or one of its subclasses like SpriteComponent), which handles how the enemy is rendered and interacts with other components in the game world.