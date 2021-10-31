/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.d3d12.queryd3d12;

/// \file
/// Definition of the Diligent::IQueryD3D12 interface

import bindbc.diligent.graphics.query;

// {72D109BE-7D70-4E54-84EF-C649DA190B2C}
static const INTERFACE_ID IID_QueryD3D12 =
    INTERFACE_ID(0x72d109be, 0x7d70, 0x4e54, [0x84, 0xef, 0xc6, 0x49, 0xda, 0x19, 0xb, 0x2c]);

/// Exposes Direct3D12-specific functionality of a Query object.
struct IQueryD3D12Methods
{
    extern(C) @nogc nothrow {
        /// Returns the Direct3D12 query heap that internal query object resides in.
        ID3D12QueryHeap** GetD3D12QueryHeap(IQueryD3D12*);

        /// Returns the index of a query object in Direct3D12 query heap.

        /// \param [in] QueryId - Query Id. For most query types this must be 0. An exception is
        ///                       QUERY_TYPE_DURATION, in which case allowed values are 0 for the
        ///                       beginning timestamp query, and 1 for the ending query.
        /// \return the index of a query object in Direct3D12 query heap
        uint* GetQueryHeapIndex(IQueryD3D12*, uint QueryId);
    }
}

struct IQueryD3D12Vtbl { IQueryD3D12Methods QueryD3D12; }
struct IQueryD3D12 { IQueryD3D12Vtbl* pVtbl; }

ID3D12QueryHeap** IQueryD3D12_GetD3D12QueryHeap(IQueryD3D12* query) {
    return query.pVtbl.QueryD3D12.GetD3D12QueryHeap(query);
}

uint* IQueryD3D12_GetQueryHeapIndex(IQueryD3D12* query, uint queryID) {
    return query.pVtbl.QueryD3D12.GetQueryHeapIndex(query, queryID);
}