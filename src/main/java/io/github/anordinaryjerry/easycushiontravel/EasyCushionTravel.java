package io.github.anordinaryjerry.easycushiontravel;

import com.mojang.brigadier.Command;
import com.mojang.brigadier.context.CommandContext;
import net.fabricmc.api.ModInitializer;
import net.fabricmc.fabric.api.command.v2.CommandRegistrationCallback;
import net.minecraft.commands.CommandSourceStack;
import net.minecraft.commands.Commands;
import net.minecraft.commands.functions.CommandFunction;
import net.minecraft.network.chat.Component;
import net.minecraft.resources.Identifier;
import net.minecraft.server.MinecraftServer;
import net.minecraft.server.ServerFunctionManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;

public class EasyCushionTravel implements ModInitializer {
	public static final String MOD_ID = "easycushiontravel";

	// This logger is used to write text to the console and the log file.
	// It is considered best practice to use your mod id as the logger's name.
	// That way, it's clear which mod wrote info, warnings, and errors.
	public static final Logger LOGGER = LoggerFactory.getLogger(MOD_ID);

	@Override
	public void onInitialize() {
		// This code runs as soon as Minecraft is in a mod-load-ready state.
		// However, some things (like resources) may still be uninitialized.
		// Proceed with mild caution.

		LOGGER.info("Hello Fabric world!");
		CommandRegistrationCallback.EVENT.register((dispatcher, registryAccess, environment) -> {
			dispatcher.register(Commands.literal("ct").executes(EasyCushionTravel::toggleTravel));
		});
	}

	private static int toggleTravel(CommandContext<CommandSourceStack> context) {
		// Steps to fill in, one at a time:
		// 1. get the source from the context
		CommandSourceStack source = context.getSource();
		// 2. get the server from the source
		MinecraftServer server = source.getServer();
		// 3. get the function manager from the server
		ServerFunctionManager functionManager = server.getFunctions();
		// 4. look up the toggle function with id("toggle")
		Optional<CommandFunction<CommandSourceStack>> toggleFunction = functionManager.get(id("toggle"));
		// 5. if the lookup is empty, send a failure message and return 0
		if (toggleFunction.isEmpty()) {
			source.sendFailure(Component.literal("Failed to initiate Easy Cushion Travel."));
			return 0;
		}
		// 6. run the function with the source (output suppressed)
		functionManager.execute(toggleFunction.get(), source.withSuppressedOutput());
		// 7. return success
		return Command.SINGLE_SUCCESS;
	}

	public static Identifier id(String path) {
		return Identifier.fromNamespaceAndPath(MOD_ID, path);
	}
}
