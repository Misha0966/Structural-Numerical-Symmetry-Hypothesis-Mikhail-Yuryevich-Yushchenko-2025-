using Printf
using CSV
using DataFrames

# Splits number N into m parts as evenly as possible
function split_number(N::Integer, m::Integer)
    s = string(N)
    len = length(s)
    base_len = div(len, m)
    remainder = len % m

    parts = String[]
    idx = 1

    for i in 1:m
        current_len = base_len + (i <= remainder ? 1 : 0)
        push!(parts, s[idx:idx+current_len-1])
        idx += current_len
    end

    return [parse(BigInt, p) for p in parts]
end

# Compares PQ and N*k to determine match type
function compare_pq_nk(pq::String, nk::String)
    if pq == nk
        return "✅ Full Match"
    elseif startswith(nk, first(pq)) && endswith(nk, last(pq))
        return "🔄 Start and End Match"
    elseif startswith(nk, first(pq))
        return "🔄 Start Match"
    elseif endswith(nk, last(pq))
        return "🔄 End Match"
    else
        return "❌ No Match"
    end
end

# Checks the hypothesis for a single number N
function check_hypothesis(N::Integer, m::Integer, k::Integer)
    nk = string(N * k)
    parts = split_number(N, m)
    pq_parts = [string(p * k) for p in parts]
    pq = join(pq_parts)

    result = compare_pq_nk(pq, nk)

    return (
        N = N,
        m = m,
        k = k,
        parts = string(parts),
        multiplied_parts = string([p * k for p in parts]),
        PQ = pq,
        NK = nk,
        result = result
    )
end

# Runs hypothesis checks over a range of numbers
function run_tests(start_N::Integer, stop_N::Integer, m::Integer, k::Integer)
    results_df = DataFrame(
        N = BigInt[],
        m = Int[],
        k = Int[],
        parts = String[],
        multiplied_parts = String[],
        PQ = String[],
        NK = String[],
        result = String[]
    )

    count_full = 0
    count_start = 0
    count_end = 0
    count_both = 0
    count_none = 0

    @printf("\n🚀 Running hypothesis tests\n")
    @printf("Range: [%d, %d], m = %d, k = %d\n", start_N, stop_N, m, k)

    for N in start_N:stop_N
        print("\r🔍 Testing N = $N...")

        res = check_hypothesis(N, m, k)

        push!(results_df, [
            res.N
            res.m
            res.k
            res.parts
            res.multiplied_parts
            res.PQ
            res.NK
            res.result
        ])

        if res.result == "✅ Full Match"
            count_full += 1
        elseif res.result == "🔄 Start Match"
            count_start += 1
        elseif res.result == "🔄 End Match"
            count_end += 1
        elseif res.result == "🔄 Start and End Match"
            count_both += 1
        else
            count_none += 1
        end
    end

    println("\n💾 Saving results to CSV...")
    CSV.write("results.csv", results_df)

    println("\n📊 Statistics:")
    @printf("  ✅ Full Matches: %d\n", count_full)
    @printf("  🔄 Start Matches: %d\n", count_start)
    @printf("  🔄 End Matches: %d\n", count_end)
    @printf("  🔄 Start & End Matches: %d\n", count_both)
    @printf("  ❌ No Matches: %d\n", count_none)

    println("\n📄 Results saved to 'results.csv'")
    return results_df
end

# User-defined parameters
start_N = 10
stop_N = 100
m = 2
k = 7

# Run the test
run_tests(start_N, stop_N, m, k)