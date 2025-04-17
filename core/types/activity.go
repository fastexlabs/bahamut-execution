package types

import (
	"bytes"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/rlp"
)

//go:generate go run ../../rlp/rlpgen -type Activity -out gen_activity_rlp.go

type Activity struct {
	Address       common.Address `json:"contract_address"`
	DeltaActivity uint64         `json:"delta_activity"`
}

type Activities []*Activity

func (a Activities) Len() int { return len(a) }

func (a Activities) EncodeIndex(i int, w *bytes.Buffer) {
	rlp.Encode(w, a[i])
}
