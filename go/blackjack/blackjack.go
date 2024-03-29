package blackjack

const (
	Hit   = "H"
	Split = "P"
	Stand = "S"
	Win   = "W"
)

// ParseCard returns the integer value of a card following blackjack ruleset.
func ParseCard(card string) int {
	switch card {
	case "ace":
		return 11
	case "two":
		return 2
	case "three":
		return 3
	case "four":
		return 4
	case "five":
		return 5
	case "six":
		return 6
	case "seven":
		return 7
	case "eight":
		return 8
	case "nine":
		return 9
	case "ten", "jack", "queen", "king":
		return 10
	default:
		return 0
	}
}

// FirstTurn returns the decision for the first turn, given two cards of the
// player and one card of the dealer.
func FirstTurn(card1, card2, dealerCard string) string {
	switch {
	case ParseCard(card1)+ParseCard(card2) > 20:
		return LargeHand(isBlackjack(card1, card2), ParseCard(dealerCard))
	default:
		return SmallHand(ParseCard(card1)+ParseCard(card2), ParseCard(dealerCard))
	}

}

// LargeHand implements the decision tree for hand scores larger than 20 points.

func LargeHand(isBlackjack bool, dealerScore int) string {
	switch {
	case !isBlackjack:
		return Split
	case dealerScore < 10:
		return Win
	default:
		return Stand
	}
}

// SmallHand implements the decision tree for hand scores with less than 21 points.

func SmallHand(handScore, dealerScore int) string {
	switch {
	case handScore <= 11 || (dealerScore >= 7 && handScore < 17):
		return Hit
	default:
		return Stand
	}
}

func isBlackjack(card1, card2 string) bool {
	return ParseCard(card1)+ParseCard(card2) == 21
}
