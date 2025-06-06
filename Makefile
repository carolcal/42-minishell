# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: naharumi <naharumi@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/06 16:15:25 by cayamash          #+#    #+#              #
#    Updated: 2025/04/09 15:56:40 by naharumi         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Name of the program
NAME = minishell
NAME_BONUS = minishell_bonus

# Compilers and flags
CC = cc
CFLAGS = -Wall -Wextra -Werror
LDFLAGS = -lreadline -lncurses

# Library
LIBFT = lib

# Directories
SRC_DIR = src/
INI_DIR = src/init/
SIG_DIR = src/signals/
ENV_DIR = src/ev/
INP_DIR = src/input/
TOK_DIR = src/tokenizer/
PRS_DIR = src/parser/
EXP_DIR = src/expansion/
BUT_DIR = src/builtins/
EXE_DIR = src/execution/
UTI_DIR = src/utils/
OBJ_DIR = obj/
INCLUDES = -I inc/ -I $(LIBFT)

# Source files and object files
SRC = $(addprefix $(SRC_DIR), main.c) \
		$(addprefix $(INI_DIR), init.c) \
		$(addprefix $(SIG_DIR), signals.c handle_signal.c) \
		$(addprefix $(ENV_DIR), ev_init.c ev_print.c ev_utils.c) \
		$(addprefix $(INP_DIR), input.c input_check.c input_syntax.c) \
		$(addprefix $(TOK_DIR), tokenizer.c token_utils.c) \
		$(addprefix $(PRS_DIR), parser.c parser_ops.c parser_heredoc.c parser_search.c parser_utils.c) \
		$(addprefix $(EXP_DIR), expand.c expand_token.c expand_wildcards.c expand_split.c expand_utils.c) \
		$(addprefix $(BUT_DIR), builtins.c cd.c echo.c env.c exit.c export.c pwd.c unset.c) \
		$(addprefix $(EXE_DIR), find_command.c exec_path.c exec_pipe.c exec_redir.c exec_submodule.c executor.c) \
		$(addprefix $(UTI_DIR), utils.c utils_error.c)
OBJ = $(SRC:$(SRC_DIR)%.c=$(OBJ_DIR)%.o)

# Valgrind
VALGRIND = valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all --suppressions=readline.supp

# Style
NO_PRINT = --no-print-directory
GREEN	= \033[1;32m
BLUE	= \033[1;36m
YELLOW	= \033[1;33m
MAGENTA	= \033[1;35m
END		= \033[0m

# Rules
all: libft $(NAME)

bonus: libft $(NAME_BONUS)

libft:
	@make -C $(LIBFT) $(NO_PRINT)

norm:
	@echo "\n$(BLUE)======= INCLUDES =======$(END)"
	@norminette inc | sed 's/OK/\x1b[1;32m&\x1b[0m/g' | sed 's/Error/\x1b[1;31m&\x1b[0m/g'
	@echo "\n$(YELLOW)========= LIB =========$(END)"
	@norminette lib | sed 's/OK/\x1b[1;32m&\x1b[0m/g' | sed 's/Error/\x1b[1;31m&\x1b[0m/g'
	@echo "\n$(MAGENTA)========= SRC =========$(END)"
	@norminette src | sed 's/OK/\x1b[1;32m&\x1b[0m/g' | sed 's/Error/\x1b[1;31m&\x1b[0m/g'

# Compile object files
$(OBJ_DIR)%.o: $(SRC_DIR)%.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Executable
$(NAME): $(OBJ)
	@$(CC) $(CFLAGS) $(OBJ) -L$(LIBFT) -lft $(LDFLAGS) -o $(NAME)
	@echo "$(GREEN)Minishell Compiled!$(END)"

$(NAME_BONUS): $(OBJ)
	@$(CC) $(CFLAGS) $(OBJ) -L$(LIBFT) -lft $(LDFLAGS) -o $(NAME_BONUS)
	@echo "$(GREEN)Minishell Compiled!$(END)"

# Clean objects
clean:
	@rm -rf $(OBJ_DIR)
	@make -C $(LIBFT) clean $(NO_PRINT)
	@echo "$(GREEN)Cleaned$(END)"

# Clean all generated file
fclean: clean
	@rm -rf $(NAME) $(NAME_BONUS)
	@make -C $(LIBFT) fclean $(NO_PRINT)
	@rm -f valgrind.log
	@echo "$(GREEN)All!$(END)"

val: re
	@valgrind -q --suppressions=readline.supp \
				--leak-check=full \
				--show-leak-kinds=all \
				--track-origins=yes \
				--track-fds=yes \
				--trace-children=yes \
				--trace-children-skip='*/bin/*,*/sbin/*,/usr/bin/*' \
				./${NAME}

# Recompile everything
re: fclean all

.PHONY: all bonus clean fclean re val norm libft
