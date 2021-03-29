@testset "Polymake.Graph" begin

    @testset "Directed" begin
        square = Polymake.polytope.cube(2);
        gd = square.HASSE_DIAGRAM.ADJACENCY;
        @test gd isa Polymake.Graph{Polymake.Directed}
        @test edges(gd) isa Polymake.PmGraphEdgeIterator{Polymake.Directed}
        @test vertices(gd) isa Polymake.PmGraphVertexIterator{Polymake.Directed}
        @test nv(gd) == 10
        @test ne(gd) == 16
        @test has_vertex(gd, 1)
        @test collect(outneighbors(gd, 1)) == [2;3;4;5]
        @test collect(inneighbors(gd, 2)) == [1]
        @test collect(vertices(gd)) == [1;2;3;4;5;6;7;8;9;10]
        @test size(collect(edges(gd))) == (16,)
    end
    
    @testset "Undirected" begin
        complete = Polymake.graph.complete(4)
        gu = complete.ADJACENCY
        @test gu isa Polymake.Graph{Polymake.Undirected}
        @test edges(gu) isa Polymake.PmGraphEdgeIterator{Polymake.Undirected}
        @test vertices(gu) isa Polymake.PmGraphVertexIterator{Polymake.Undirected}
        @test nv(gu) == 4
        @test ne(gu) == 6
        @test has_vertex(gu, 1)
        @test collect(outneighbors(gu, 2)) == [1;3;4]
        @test outneighbors(gu,2) == inneighbors(gu,2)
        @test collect(vertices(gu)) == [1;2;3;4]
        @test size(collect(edges(gu))) == (6,)
    end

end
